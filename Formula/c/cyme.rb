class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https:github.comtuna-f1shcyme"
  url "https:github.comtuna-f1shcymearchiverefstagsv1.8.4.tar.gz"
  sha256 "f9136c5794c4d199ee3d7745b82e901de4a15e4626f3bb4c9269e67c6e31885a"
  license "GPL-3.0-or-later"
  head "https:github.comtuna-f1shcyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e18bd476d149849dca9e3d43b4a3c1eeb8c3560fee4def60208cb5fe8f070e77"
    sha256 cellar: :any,                 arm64_sonoma:  "381e8ccf170104d9deef6fa283e347108bfd59c1d871d4fd7193c59ddfc60ce8"
    sha256 cellar: :any,                 arm64_ventura: "540c3d6636ea6edbc92985328198b6046414d7e7efb68f1810e6bb333b3f6791"
    sha256 cellar: :any,                 sonoma:        "08ebe554f70c67aeca385a4852da1ca76e31d24080831d0f9332974fa0bd090c"
    sha256 cellar: :any,                 ventura:       "b60b15d2d2146619e340ea784adad284dff72f1bf03e45a13f16bbc8c2d891a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ecce228a0159f178bf7502e97a25397bfe8e468f103e8ee7881fd461c0ff22c"
  end

  depends_on "rust" => :build
  depends_on "libusb"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doccyme.1"
    bash_completion.install "doccyme.bash"
    zsh_completion.install "doc_cyme"
    fish_completion.install "doccyme.fish"
  end

  test do
    # Test fails on headless CI
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = JSON.parse(shell_output("#{bin}cyme --tree --json"))
    assert_predicate output["buses"], :present?
  end
end