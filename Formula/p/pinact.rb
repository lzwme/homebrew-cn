class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https:github.comsuzuki-shunsukepinact"
  url "https:github.comsuzuki-shunsukepinactarchiverefstagsv3.0.2.tar.gz"
  sha256 "dbeab4059bf793c1f60be87667f14d26ca2bb9f5f8b948b56d027c044f4fd4ca"
  license "MIT"
  head "https:github.comsuzuki-shunsukepinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a43824ca36c6a7741c450ed5e7315e17115625a32140824bd7e2dc6c9ce3fda7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a43824ca36c6a7741c450ed5e7315e17115625a32140824bd7e2dc6c9ce3fda7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a43824ca36c6a7741c450ed5e7315e17115625a32140824bd7e2dc6c9ce3fda7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4de248189d986f7eb97a69c00eb8336dfc248761f120ef9dacb37782e4bf8ca"
    sha256 cellar: :any_skip_relocation, ventura:       "f4de248189d986f7eb97a69c00eb8336dfc248761f120ef9dacb37782e4bf8ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0cdaedc0b117ce77cf3deded8efd2a97c84b992b1fe7cad6f7468fc9256a8f0"
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