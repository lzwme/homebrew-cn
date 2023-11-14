class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://ghproxy.com/https://github.com/yitsushi/totp-cli/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "52510897ad87b9d0a2c72250f95da0dbcde96b4b5753ea8cbe1569830826ee77"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d9bb6fb4d9da398a9999f40285c6691b7621f614dbb5105f085c1b5b1c7c3f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d9bb6fb4d9da398a9999f40285c6691b7621f614dbb5105f085c1b5b1c7c3f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d9bb6fb4d9da398a9999f40285c6691b7621f614dbb5105f085c1b5b1c7c3f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3d77d5d3e54751a4a79911f50985305bbde6b8eaa7d56adf8937acc74ad4f65"
    sha256 cellar: :any_skip_relocation, ventura:        "e3d77d5d3e54751a4a79911f50985305bbde6b8eaa7d56adf8937acc74ad4f65"
    sha256 cellar: :any_skip_relocation, monterey:       "e3d77d5d3e54751a4a79911f50985305bbde6b8eaa7d56adf8937acc74ad4f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95b354ae32b67f28bf6c87de954a4ac6020ca8e6e4115a825db6693452a42980"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "autocomplete/bash_autocomplete" => "totp-cli"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_totp-cli"
  end

  test do
    assert_match "generate", shell_output("#{bin}/totp-cli help")
    assert_match "storage error", pipe_output("#{bin}/totp-cli list 2>&1", "")
  end
end