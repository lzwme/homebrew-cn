class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https:github.comtuna-f1shcyme"
  url "https:github.comtuna-f1shcymearchiverefstagsv1.8.2.tar.gz"
  sha256 "5313770f54f4acf16e44d8e159d0608cf6fdf534d504ee4a545fb81f68883879"
  license "GPL-3.0-or-later"
  head "https:github.comtuna-f1shcyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f03c742b585e910c22854123a6480a7065e49bc963eda2035044f437cc3d92ed"
    sha256 cellar: :any,                 arm64_ventura:  "b128d3a36f0883b5411b064804b6a3f408bf9a2e94214e65b97a4640b77cc5fc"
    sha256 cellar: :any,                 arm64_monterey: "8f662d1b53801dd8128ffc82071c33f60ee1d6f402c51e8bef6ee29637c1f5b4"
    sha256 cellar: :any,                 sonoma:         "fade2e9a5616805b667973bb23c80a2c356eb4ffd75e0e21014c95f359e30c89"
    sha256 cellar: :any,                 ventura:        "d7cc9f70d43e14bdfa8ca970f63e9cf559ea3a11717727a7f0eec3b42aaf4e09"
    sha256 cellar: :any,                 monterey:       "90cfc106c8ed5710952ac6aa7f0cbc06f7254b9d6986d9efcc60ef4caf4aa48b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb3f8ef945ac11a30208b238187c08aa945d0d09bce2e249af2b1d64e33922d3"
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