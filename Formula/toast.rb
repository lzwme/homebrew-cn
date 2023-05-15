class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://ghproxy.com/https://github.com/stepchowfun/toast/archive/v0.47.2.tar.gz"
  sha256 "38c4ac9e5b3c25513ca40b6e0788ea350850cc0eed7785ab7a930964352b67a6"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8533bf31802ad71191ef4c105d8dd515257852f6fbc987f5794c745e5d59bb2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78e1bbf08336823e07130b3f9646828e1d35fa233bb2244f906f26abdf9f0e09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "203d21ba2ad9852c03422a3abfe0f5aa88da0483103880ffdba1284ebadbcf4a"
    sha256 cellar: :any_skip_relocation, ventura:        "8a131c601881373ec587a93a11ba2033396fcbaf26b29e8e30405aa2e48b4826"
    sha256 cellar: :any_skip_relocation, monterey:       "a154744a22cb00c59c8225ae67ba5c1a59847069a3c7a12be3416ce08aec1823"
    sha256 cellar: :any_skip_relocation, big_sur:        "21bf97da465f0875c3ccba3a11dde4bbba20c76c5d45d555e55f666276f4fbf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c99a4935d6bb74ef8ad6ecc0b70d7315f16185a6c94dadfd48cde578fbd2b38"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"toast.yml").write <<~EOS
      image: alpine
      tasks:
        homebrew_test:
          description: brewtest
          command: echo hello
    EOS

    assert_match "homebrew_test", shell_output("#{bin}/toast --list")
  end
end