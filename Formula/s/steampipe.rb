class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https:steampipe.io"
  url "https:github.comturbotsteampipearchiverefstagsv0.21.3.tar.gz"
  sha256 "5ebcaa095a117e124f4968562031b1e1375f67b815bb1fcd167df0fc40cf20f2"
  license "AGPL-3.0-only"
  head "https:github.comturbotsteampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03d0be8b8d78f258604d62679d55c051cd582552b277bebc89048b186f34905b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7bd7873f52c2ceef0b28a4dec52ef9767bc5eea749c7952043e77dac9f6887c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14e4de88983213748496c925f08c214686fb3dc7d048ec08161634ddbe4f88f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "86aa55621ae16ad91b74f7adc256420b5db37f6a689c127f9578c6f1d3666e73"
    sha256 cellar: :any_skip_relocation, ventura:        "d5b6359a170673f60a8ef32304b6f954f8407a24a9604223ea8045782546b0eb"
    sha256 cellar: :any_skip_relocation, monterey:       "32b085445ddac2ebaee4e3f9754b95d10b2d880f8dfdc881d8a85f7b200941d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a8dcd028ee4248e904f6235183afe5087255dcd540a3225ef9642c3bc2e03d4"
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