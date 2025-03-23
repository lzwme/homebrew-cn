class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https:github.comsuzuki-shunsukepinact"
  url "https:github.comsuzuki-shunsukepinactarchiverefstagsv2.0.4.tar.gz"
  sha256 "1e448da8a4b2be37f6a27809717840f47e58efca44e2883a7f7a39f535b59e8c"
  license "MIT"
  head "https:github.comsuzuki-shunsukepinact.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f69c09fffee64e98879a8b246e96a7c5836ada016f726e8fcabef1c73ceb401e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f69c09fffee64e98879a8b246e96a7c5836ada016f726e8fcabef1c73ceb401e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f69c09fffee64e98879a8b246e96a7c5836ada016f726e8fcabef1c73ceb401e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b2606a2f0369e755b50d8a6a030884b8f52251db1e6f73142516f523e333d6e"
    sha256 cellar: :any_skip_relocation, ventura:       "9b2606a2f0369e755b50d8a6a030884b8f52251db1e6f73142516f523e333d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5944cc9f1d0a67ba211f85de44893e1e84043d5b7a9059c59dcc3c47f15a506d"
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