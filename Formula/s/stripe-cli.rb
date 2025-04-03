class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https:docs.stripe.comstripe-cli"
  url "https:github.comstripestripe-cliarchiverefstagsv1.26.0.tar.gz"
  sha256 "bed2321d379c5c8dd96116b7a636df1678eb4898c6abb37dde3c4657f0f76587"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a51a82db44a2da36ad952c7eeacf2d5548d533a1c5da74400c4e464a85ca9e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dec59e3a1d59c00522fea7877057540bdf07200b95407c4dfa43980732a3c38a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc008539ab6394da5551af2f05f534271aefa5d13e0b4cf878d648e0cbc727f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf0975532fe34d6fc232b63eb0b9f83f976d666ff39e64a4b10fda24a0cadc16"
    sha256 cellar: :any_skip_relocation, ventura:       "a8aa9b7c45ac63bc740773b08a4ab8bf3b25fd904d5e12302f109eff2431ce63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc8d9ee3c95ee12defc19e200be4648db52661fa5d31f7a3618056107cd3b75b"
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