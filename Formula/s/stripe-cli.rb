class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.40.6.tar.gz"
  sha256 "26f72406aefc42b134ca4c908c514c7985ec6a08045a1d0e2cc74c104785a35b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6565f1bfbfc4aa185464288febcbfc562a4b8f4ab4465757b23b56db30a4a45b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae199299ede3b92e0d74bb7ad74e9274c131ec0e2de4b0a4c964aae6ed0a7bb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02263896e15c45c20fad15e664592ea3f5d414bd5dc596a2d6a2ab11f6742b65"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee3a0e442a451146a8c82e6a27694db044b2ce48117bae9ed58513ad352b62ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e95333d062e6141e05150fd5bafbb5d20870b3227c2acc35cf8033a1d4851f01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c12fe33718f0d86fd84827a71af13df7d1a6927eb767b0c117b22327ba06446"
  end

  depends_on "go" => :build

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-s -w -X github.com/stripe/stripe-cli/pkg/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"stripe"), "cmd/stripe/main.go"

    generate_completions_from_executable(bin/"stripe", "completion", "--write-to-stdout", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stripe version")
    assert_match "secret or restricted key",
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha 2>&1", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}/stripe && complete -p stripe'")
  end
end