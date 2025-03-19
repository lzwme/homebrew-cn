class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https:github.comsuzuki-shunsukepinact"
  url "https:github.comsuzuki-shunsukepinactarchiverefstagsv1.4.0.tar.gz"
  sha256 "34722b6e78cbc11c650f2ab48f0028dafb3a794ad0723bcc131431228bd02a2d"
  license "MIT"
  head "https:github.comsuzuki-shunsukepinact.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8947211dcb15eb8e4e960f4d6f2bfcd53ebca2b3510a42f4c07462b38f73691"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8947211dcb15eb8e4e960f4d6f2bfcd53ebca2b3510a42f4c07462b38f73691"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8947211dcb15eb8e4e960f4d6f2bfcd53ebca2b3510a42f4c07462b38f73691"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef67461f5be647e9805e724d2a260f0e204fe4800d584134d546d91ebcd25747"
    sha256 cellar: :any_skip_relocation, ventura:       "ef67461f5be647e9805e724d2a260f0e204fe4800d584134d546d91ebcd25747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "663c8ecc11fe32b131c7c6c127379ba56005562b1b5beb7263d5d4d84ad2c268"
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