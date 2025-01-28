class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https:stripe.comdocsstripe-cli"
  url "https:github.comstripestripe-cliarchiverefstagsv1.23.9.tar.gz"
  sha256 "a6f561cd2585578513a759b187172fe09c198e27416ef937ace86d8e86ca5ed1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cf46cfc2099f6ddaa138e23f53ff864063751b207d04d414e95e54c6924c962"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e76b5726778002a7c278111424f797b4b8490146852a4fb4e460150b814365c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e868a953451eb904f52dda382cf7b3064dd25cb9eaae4271c06a052afa821ab8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a618fada1b1bcb2acab1da0badfc93a2a4c1fbad3cef1bd6bb0170f1134de2ca"
    sha256 cellar: :any_skip_relocation, ventura:       "93ca7253eaa02dcc0ea8a2ab3b4387ec1fbff47c9c09239358fccc0be8b0cebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bacb25993f12f8b07b04cd285a432206e8219bf01a127eef966345830bd84732"
  end

  depends_on "go" => :build

  # fish completion support patch, upstream pr ref, https:github.comstripestripe-clipull1282
  patch do
    url "https:github.comstripestripe-clicommitde62a98881671ce83973e1b696d3a7ea820b8d0e.patch?full_index=1"
    sha256 "2b30ee04680e16b5648495e2fe93db3362931cf7151b1daa1f7e95023b690db8"
  end

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-s -w -X github.comstripestripe-clipkgversion.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin"stripe"), "cmdstripemain.go"

    generate_completions_from_executable(bin"stripe", "completion", "--write-to-stdout", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}stripe version")
    assert_match "secret or restricted key",
                 shell_output("#{bin}stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}stripe && complete -p stripe'")
  end
end