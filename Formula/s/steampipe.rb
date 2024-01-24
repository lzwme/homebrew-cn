class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https:steampipe.io"
  url "https:github.comturbotsteampipearchiverefstagsv0.21.4.tar.gz"
  sha256 "bd709dda03ce3b42b44c53c16525700cad66e39a20e1910e51c91b85e9a2b5bc"
  license "AGPL-3.0-only"
  head "https:github.comturbotsteampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e491358b19f3c3a08ae452dc62985d74894502e517c06cab7813fe778d47dc3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d4bc7548a3961ee104e548a8d22aae908ff48db0b5502f44e8327eb03dc5db8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4888afe30c13f96d612037f12034de015d7e977b26ae171cf80292ef340cad40"
    sha256 cellar: :any_skip_relocation, sonoma:         "b128f694101a689085cafb4ae23096fd7ae9478cbb84b3a566933e193da6ac47"
    sha256 cellar: :any_skip_relocation, ventura:        "e9bb23c33498a337de326b0d6be025983c1849bf9522587ff096d78f5f7d39ae"
    sha256 cellar: :any_skip_relocation, monterey:       "6be3fa5c4a43f9c406941343ecd535d508382443c57bfc2a9f79c034517b425c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "588e450cad722bb93d0b320ee9ee1c8b2db4e225accd68b64ff1e155a7810715"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin"steampipe service status 2>&1", 255)
      assert_match "Error: could not create sample workspace", output
    else # Linux
      output = shell_output(bin"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin"steampipe --version")
  end
end