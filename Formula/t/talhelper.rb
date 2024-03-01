class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv2.3.2.tar.gz"
  sha256 "62572b94920acd10a292c02ebb27adee2f29e9d4e762bb3303b809020312ee0c"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4462b501b59c94e73d00ed54d9593c8e251413d31c10f0ade3c8f30945fe3188"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48862da3b58a18605e3d897e556bd8ca9da4d4583240551eaacf578ecfe32bbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd60433a6b28879ab5fc6f08b108cd5dc86f7d44c64030f93d6f8a86ce194411"
    sha256 cellar: :any_skip_relocation, sonoma:         "adfd3baff10c43d6f42cf9ff3e08d3fc6f693a56efaf3db2feb37b0470dbb18b"
    sha256 cellar: :any_skip_relocation, ventura:        "2e56d434a1e2449c1f758568e55b992327ab8924101d77ac5bbdd6f6172847ef"
    sha256 cellar: :any_skip_relocation, monterey:       "c082550f26c30bd34ad8e6f7e3965a1cdbd2081d3f60c0689f1116e577c0689b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aedb03129e061acc0527ff8aed48ca1a3b635c841a30b9d10c6a063484c3f9b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelpercmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}example*"], testpath

    output = shell_output("#{bin}talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}talhelper --version")
  end
end