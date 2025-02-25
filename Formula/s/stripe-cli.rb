class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https:docs.stripe.comstripe-cli"
  url "https:github.comstripestripe-cliarchiverefstagsv1.24.0.tar.gz"
  sha256 "5d1d2957b378ba354b3477923a753250ec4f27339e358bdf7e8a2b1e09bd785e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f6db139e6996197a1bbe8f02cc9ebdf1b717bdf0ad52fc8ff7c934d7a5f8cac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa49a048a4c43c5898df1dc4b4a89239206bdbdae6ecce4f0c24274cf7877da5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "055578c6d4c42017e68f32b705cce4ea2d15a3dbf1e0448fcdbbbfe8535bf665"
    sha256 cellar: :any_skip_relocation, sonoma:        "44e48c459f1b121f80d2cd728698d9bead31ddc0919ca8c7bfc67e7ef4e185c0"
    sha256 cellar: :any_skip_relocation, ventura:       "c9917120c3c4a71a84761ccbe451547395a02b48d6bf7e7ec6169efe55240ee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "038833dd46bf2e025d41d35cb86169e535d8c67e9091afb03d6dfa47c62d5746"
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