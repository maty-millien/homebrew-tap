class Ggx < Formula
  desc "A fast AI-powered git workflow CLI"
  homepage "https://github.com/maty-millien/ggx"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maty-millien/ggx/releases/download/v0.5.1/ggx-aarch64-apple-darwin.tar.xz"
      sha256 "550cda6b825a117c5aeb6d453e1fc15f791033c62eb50e9ffe571711e4fd0742"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maty-millien/ggx/releases/download/v0.5.1/ggx-x86_64-apple-darwin.tar.xz"
      sha256 "c6c187fc4a8cf07379584f489a39d1a8f5b53b14cbffc7f3f70b87704cf20c60"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/maty-millien/ggx/releases/download/v0.5.1/ggx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "559539681e042b091ed153b26f1c5b9a20c1dfc744718cc47dac942387568bd4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maty-millien/ggx/releases/download/v0.5.1/ggx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "db799fe31802b256972ec7849bde3a022a906eb0d257c22019df85b8b7ecbd0b"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "ggx" if OS.mac? && Hardware::CPU.arm?
    bin.install "ggx" if OS.mac? && Hardware::CPU.intel?
    bin.install "ggx" if OS.linux? && Hardware::CPU.arm?
    bin.install "ggx" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
