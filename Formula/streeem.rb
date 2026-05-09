class Streeem < Formula
  desc "Rust TUI that hosts multiple interactive terminals in a staggered grid"
  homepage "https://github.com/3moeslam/streeem"
  version "0.2.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/3moeslam/streeem/releases/download/v0.2.7/streeem-aarch64-apple-darwin.tar.xz"
      sha256 "8567a6229e1130a87d88d5a3b3f2b3994f1f6853edaf83ce1f368b31b2ccd928"
    end
    if Hardware::CPU.intel?
      url "https://github.com/3moeslam/streeem/releases/download/v0.2.7/streeem-x86_64-apple-darwin.tar.xz"
      sha256 "a28bc58b738c4ffb4b7b604406f6d29f4c4fe5d569f918a91f17395059ebb772"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "streeem" if OS.mac? && Hardware::CPU.arm?
    bin.install "streeem" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
