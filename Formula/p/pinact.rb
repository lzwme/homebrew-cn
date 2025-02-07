class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https:github.comsuzuki-shunsukepinact"
  url "https:github.comsuzuki-shunsukepinactarchiverefstagsv1.2.1.tar.gz"
  sha256 "320a6fd6634a958822fe1b10f78fdd15f53df65b26b0086fa93fff6d9568d916"
  license "MIT"
  head "https:github.comsuzuki-shunsukepinact.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32c26c242d9811ef6638eee692db928e73e1414e144596bfb8eb4eff90c6a542"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32c26c242d9811ef6638eee692db928e73e1414e144596bfb8eb4eff90c6a542"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32c26c242d9811ef6638eee692db928e73e1414e144596bfb8eb4eff90c6a542"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d1edcce660b0f49fba5c3423a4dd1636f2bc76b23627cf2367f041caa8c75a3"
    sha256 cellar: :any_skip_relocation, ventura:       "7d1edcce660b0f49fba5c3423a4dd1636f2bc76b23627cf2367f041caa8c75a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4f7835fa328625a885a971fef65a75e322f8293d43fd981b316110d9e422895"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdpinact"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pinact --version")

    (testpath"action.yml").write <<~YAML
      name: CI

      on: push

      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actionscheckout@v3
            - run: npm install && npm test
    YAML

    system bin"pinact", "run", "action.yml"

    assert_match(%r{.*?actionscheckout@[a-f0-9]{40}}, (testpath"action.yml").read)
  end
end