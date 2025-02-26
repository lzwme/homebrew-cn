class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https:docs.stripe.comstripe-cli"
  url "https:github.comstripestripe-cliarchiverefstagsv1.25.0.tar.gz"
  sha256 "c7e35e81ba3022278d8a1723bab039d56cc30e4e7c843721940a93fb1496b7f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56913ab103e0350c9a9766fe639c83c534fd1f2d20eb9689e10838bd6e696330"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0168e302d0e174a1bb87b162d06b5b19f01a9c7de463e580f00b8aee799acdc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75eaf47ff70e622ede67652fe83e711ea06a7da96419b3bcf038cc6d112fac13"
    sha256 cellar: :any_skip_relocation, sonoma:        "8144cc79e495ba764c4366469da130237c96d0f55c0596efabd9c1e7f57cf923"
    sha256 cellar: :any_skip_relocation, ventura:       "3ed4af7ea7cd644d0a0b82e114b34fc9183bda7aa78678998635c799bfb5599f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d3a7f1e6337c7366b23a21790fe00b4beb07dc49a6bd3d3126ad9a73f8a6576"
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