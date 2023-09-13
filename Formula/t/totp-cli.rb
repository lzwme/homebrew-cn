class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://ghproxy.com/https://github.com/yitsushi/totp-cli/archive/v1.6.0.tar.gz"
  sha256 "80f525cdee9c18fcc2631f94c510ad1acd87163a13be0efa01b354ab99304739"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61ee777774ac2030459ce5b7991400348223e42076af0f9c4360fbb55ebecd9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dc30adfd4beb9bb72adac32e7f0acbe33e91f283706b729a7ce51877e8a09cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b65e50ae09eebb3990dadce6718216787479460b3b1a624fbaa0b15aa33f256"
    sha256 cellar: :any_skip_relocation, ventura:        "fc486f50a35151146af2f091437af92c05b12ec8034be82cf633c9e19808c3d6"
    sha256 cellar: :any_skip_relocation, monterey:       "83741c0fd5095a8a7a1b0853a461ed976ecdc1f45a32160e616985fcf48449f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "73a69d90c74afe6d5e64a9e5332e0e0747f6f9f6b03332a3df965ddfe1a8d73b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbc9c26db1ebdc51820638c46a2f3fce1b468f14adc2b1dcc7ef1fb28d29e33c"
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