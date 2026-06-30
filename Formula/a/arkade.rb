class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.104.tar.gz"
  sha256 "df017c818e7e65fbebbd446ab4890fd051d10f01d156e25c3c2f97d961b8d188"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d080d010e5f89c3e40a5a2f42966ca8cfe2d873a2de936e2bdea4950c460431"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d080d010e5f89c3e40a5a2f42966ca8cfe2d873a2de936e2bdea4950c460431"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d080d010e5f89c3e40a5a2f42966ca8cfe2d873a2de936e2bdea4950c460431"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ee90eb88c9a56d244abe737e83779406f0b60ba7c874e86647b7a2c3bd63ee3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9293fa7e835ca2723692ca245e5defab7b30bfc55a4d660880d7b8987c743926"
    sha256 cellar: :any,                 x86_64_linux:  "809025d836b544e13c250aea6b690441ac3e7c62ddbd6d8ca73c06118c07585a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", shell_parameter_format: :cobra)
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end