class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https:github.comsuzuki-shunsukepinact"
  url "https:github.comsuzuki-shunsukepinactarchiverefstagsv1.1.2.tar.gz"
  sha256 "f41078d480ca37a945b90d8aad7cdd3e2d0aaf8dace497d592702b0a8e0de170"
  license "MIT"
  head "https:github.comsuzuki-shunsukepinact.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22f4358d5198259d6a0beb599ef61a81741667aa1082c0a391d45fb2f996950d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22f4358d5198259d6a0beb599ef61a81741667aa1082c0a391d45fb2f996950d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22f4358d5198259d6a0beb599ef61a81741667aa1082c0a391d45fb2f996950d"
    sha256 cellar: :any_skip_relocation, sonoma:        "47524b346b09ab7eab2069b440dea15c436857852de717a1343e71c3ea975f37"
    sha256 cellar: :any_skip_relocation, ventura:       "47524b346b09ab7eab2069b440dea15c436857852de717a1343e71c3ea975f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bcc22f6be636367b7e47472d6ecc0567d757f3f829efe5f4aafb50248e7c92b"
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