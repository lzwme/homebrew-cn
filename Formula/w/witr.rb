class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://ghfast.top/https://github.com/pranshuparmar/witr/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0cc73823129af9b4b183deeec31948df0fc27f231e2f697b678c5f44b575e43c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e90f192d409898d99ba8a70b5c447f4bbf4140a4d6270f305f3070faa4b2824e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e90f192d409898d99ba8a70b5c447f4bbf4140a4d6270f305f3070faa4b2824e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e90f192d409898d99ba8a70b5c447f4bbf4140a4d6270f305f3070faa4b2824e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddacf69df9740e0c9a9f3df88ab1d49ce88bbff0662339727aacacaa4fab1567"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d63bbeb8f9b6ec20e52a5d30743095b73f7eb58c4deae225809f2e6d2e12f264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96ad2f2a50047b7d2e0a77e7884bb07fd1a428b157746ec5b24b0c266b035a87"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"), "./cmd/witr"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    output = shell_output("#{bin}/witr --pid 99999999", 1)
    assert_match "No matching process or service found", output
  end
end