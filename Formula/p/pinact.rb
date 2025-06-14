class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https:github.comsuzuki-shunsukepinact"
  url "https:github.comsuzuki-shunsukepinactarchiverefstagsv3.2.0.tar.gz"
  sha256 "581f8cf101fcb64f65318c8c2bec1977e0d7da4bc773821f42e3da0e5a9cc9a0"
  license "MIT"
  head "https:github.comsuzuki-shunsukepinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f336eeae6c5c33c9a35761ac10cf76cd6b234575110a15bb022be118bdb6cf97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f336eeae6c5c33c9a35761ac10cf76cd6b234575110a15bb022be118bdb6cf97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f336eeae6c5c33c9a35761ac10cf76cd6b234575110a15bb022be118bdb6cf97"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0ef930858452b1d2336af0e2083d15313a46867d23f61b0a78e493c2ce3aa6a"
    sha256 cellar: :any_skip_relocation, ventura:       "d0ef930858452b1d2336af0e2083d15313a46867d23f61b0a78e493c2ce3aa6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c987a411b7659d94c31b31637fc74a1d4e3b3298eec12c2368b49faf86e8186"
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