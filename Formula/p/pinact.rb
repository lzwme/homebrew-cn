class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https:github.comsuzuki-shunsukepinact"
  url "https:github.comsuzuki-shunsukepinactarchiverefstagsv2.0.0.tar.gz"
  sha256 "52f407d11d599ceaba78646388850161c77eb7ccb609d0a053e70bdc3496ca79"
  license "MIT"
  head "https:github.comsuzuki-shunsukepinact.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aeb6eebba5aa97a52a520ab2c972ca896da4c2c0bc55994f789139678aa6f71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7aeb6eebba5aa97a52a520ab2c972ca896da4c2c0bc55994f789139678aa6f71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7aeb6eebba5aa97a52a520ab2c972ca896da4c2c0bc55994f789139678aa6f71"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f1c49d66c95817214beef86868c4ec39497ce59f0f36e3fd7c35308da598a6b"
    sha256 cellar: :any_skip_relocation, ventura:       "9f1c49d66c95817214beef86868c4ec39497ce59f0f36e3fd7c35308da598a6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c7fb00a71e9de2e3c46ee7ed4412373566703c7a8d14a3c91c32f39a781a5cc"
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