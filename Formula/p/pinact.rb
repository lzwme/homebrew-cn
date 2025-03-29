class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https:github.comsuzuki-shunsukepinact"
  url "https:github.comsuzuki-shunsukepinactarchiverefstagsv2.2.1.tar.gz"
  sha256 "ff7a69e58f585830d25cd4af770c664927a7d03e4682ed3482743184b2e410f9"
  license "MIT"
  head "https:github.comsuzuki-shunsukepinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3307a5fe50b657e70f7504f2453e35f0f21c61325abee74f7e189f9376ef2184"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3307a5fe50b657e70f7504f2453e35f0f21c61325abee74f7e189f9376ef2184"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3307a5fe50b657e70f7504f2453e35f0f21c61325abee74f7e189f9376ef2184"
    sha256 cellar: :any_skip_relocation, sonoma:        "315d61290d07bf538b16837c9a72aa25f21f64bb955a63ece25f444db5e4cb8a"
    sha256 cellar: :any_skip_relocation, ventura:       "315d61290d07bf538b16837c9a72aa25f21f64bb955a63ece25f444db5e4cb8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61e7f97df75f85205fd8992d6bc486414579e43ed375beda412274d664e8bf90"
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