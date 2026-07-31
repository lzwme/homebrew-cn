class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.45.0.tar.gz"
  sha256 "c61bee07f7f76172abe0a735297313801ae4b0c1fd5909435af97a9fecd185bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9431f8ba6fbd3acfa009841d3b0f03154b2a3d803ab95172f42e475c8d60317"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9431f8ba6fbd3acfa009841d3b0f03154b2a3d803ab95172f42e475c8d60317"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9431f8ba6fbd3acfa009841d3b0f03154b2a3d803ab95172f42e475c8d60317"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c8d686b093cb297ddf7f0405ec3afadb2b38efe409b38b49c71ad4dd3f6e033"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a2b42225b83520abd018c244f12517afe0effda70a166763dace6b924c2cb7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa071cdb1bc902582b947a7bbf1207592d4efb9d0917381db2aee0d8ab3921b2"
  end

  depends_on "go" => :build

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-X github.com/stripe/stripe-cli/pkg/version.Version=#{version}]
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