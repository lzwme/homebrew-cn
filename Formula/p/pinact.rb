class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https:github.comsuzuki-shunsukepinact"
  url "https:github.comsuzuki-shunsukepinactarchiverefstagsv1.3.0.tar.gz"
  sha256 "8625435f1a23a3cb392a3640eff4c44d24409242c0aeac541f00a3bd699594bd"
  license "MIT"
  head "https:github.comsuzuki-shunsukepinact.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e839534d47b9c9e4125a4626dea1918db3e60b4f01fee347b47e15618eacda3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e839534d47b9c9e4125a4626dea1918db3e60b4f01fee347b47e15618eacda3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e839534d47b9c9e4125a4626dea1918db3e60b4f01fee347b47e15618eacda3"
    sha256 cellar: :any_skip_relocation, sonoma:        "665231155ee77c7c38e1ed895548c34201b3c77afcc9f541a4fdc8f9c5d27f5b"
    sha256 cellar: :any_skip_relocation, ventura:       "665231155ee77c7c38e1ed895548c34201b3c77afcc9f541a4fdc8f9c5d27f5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d74585faa1374f7fd8b68cfa96822db36fbb32072d7df8396ee7aefbc3674a8"
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