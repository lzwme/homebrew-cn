class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:github.combudimanjojotalhelper"
  url "https:github.combudimanjojotalhelperarchiverefstagsv2.0.3.tar.gz"
  sha256 "9e496f8f42818123f413869b03f84898f10e5f46992e3de48ded89da339f5f3b"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "944c3efbf0a2da6f3c379ea07e9307f7108f133f7e48eef7d3135b5b7f641ff2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01c2a18d1e795a16e77b20b764daee0d042cc0f717a7c08b29e3ae37b2ce9345"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2183a35663d8ab49e2c0228d0259e8ddabd965e3916ee729cc49cfc7f1d42d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2d8042a3b0aca0f9865a9a501cbbd4516754b254e09d3a1ca7eca7fc6a8258c"
    sha256 cellar: :any_skip_relocation, ventura:        "cbd64336933ab64276a97c9be55b99a6e60a22099ee19148bf2d228999c9ec6a"
    sha256 cellar: :any_skip_relocation, monterey:       "c1557a391136c8885e5a7e4ae21ab8c4ffe723f780c6381181e54f25287e8213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "632f28b3757cae7024f741c7703b3fbd9d826b7f84c67e7978625e44c87fd390"
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