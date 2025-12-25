class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20251223.tgz"
  sha256 "ada64c1593f995762354dda94e43a18b1fbe92fcd6bc8abddb47d4da46638fd1"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e338651e90de27b454421f51de68c80ca3cc6a696eb0c9d47c8f85d21556490"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7475e419b1a263a6a130e58439fba469556a62b44519f9c7e1b5afedb4a8ed7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06cce5bd9e75afea8398103aff358e8273d7afafecb4729b44a96a872217ae9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cad4013b9b4cadd5e208463084986a8445987f658b0b7230708ed48937230f21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d56fa2a75570f61e009d2d41727c0a8e821e123ab98e66d00c0c8258477eef64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bc5a64aa901f4cbb23612ebf2a80eb9f1ec359bf6ec85477794d578c4dee696"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install-full"
  end

  test do
    system bin/"dialog", "--version"
  end
end