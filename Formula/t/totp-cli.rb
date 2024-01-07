class TotpCli < Formula
  desc "AuthyGoogle Authenticator like TOTP CLI tool written in Go"
  homepage "https:yitsushi.github.iototp-cli"
  url "https:github.comyitsushitotp-cliarchiverefstagsv1.8.5.tar.gz"
  sha256 "455fa11d65e770afc7b37864b385d49a020b61969e714bd1883d885265ff9832"
  license "MIT"
  head "https:github.comyitsushitotp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "86f6506ebe05ff3b3eb1ba52f1114d0e471c6ee920987ba119e690ce4ae24035"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86f6506ebe05ff3b3eb1ba52f1114d0e471c6ee920987ba119e690ce4ae24035"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86f6506ebe05ff3b3eb1ba52f1114d0e471c6ee920987ba119e690ce4ae24035"
    sha256 cellar: :any_skip_relocation, sonoma:         "f76b06b9df8823c9ad9c9874d50afd39c2ad1bfc4f3ec54b8521b5ff5f4b636c"
    sha256 cellar: :any_skip_relocation, ventura:        "f76b06b9df8823c9ad9c9874d50afd39c2ad1bfc4f3ec54b8521b5ff5f4b636c"
    sha256 cellar: :any_skip_relocation, monterey:       "f76b06b9df8823c9ad9c9874d50afd39c2ad1bfc4f3ec54b8521b5ff5f4b636c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "715dca8032892b4cbf3a8003a587176677e12ad9aefaf3f1ac93ba6abe735c2f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "autocompletebash_autocomplete" => "totp-cli"
    zsh_completion.install "autocompletezsh_autocomplete" => "_totp-cli"
  end

  test do
    assert_match "generate", shell_output("#{bin}totp-cli help")
    assert_match "storage error", pipe_output("#{bin}totp-cli list 2>&1", "")
  end
end