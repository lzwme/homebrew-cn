class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https:conduit.io"
  url "https:github.comConduitIOconduitarchiverefstagsv0.13.1.tar.gz"
  sha256 "929201cb59e28d0e26f442e8a9edc76105c31fb8a1e942457842e6c41d6e72ce"
  license "Apache-2.0"
  head "https:github.comConduitIOconduit.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afa76727e3da6eac1abbacb894b726516fb8f66f39b87ccf362cbce81d7767d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "179b499e5c1b69b5271821d0936d3672c018326a634d04bb6aef809fc1e614ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4913460f1ff221b7eade8c1a127f663bbfdf31ad0bac5e86900af3e9676cef4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7565f9198ad14561fbbf8e6c77251ccb1f1e99b0924c27ace73bab01ef4c0b8"
    sha256 cellar: :any_skip_relocation, ventura:       "457c5ad176ed11ae25272c690bd16f3af11dcc7b8658fd60425434ab2cbbbc09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5b94e77696aa3da2a525528d534bdbcf02068f6df711f91cbf3d635fa4eecc6"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "conduit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}conduit --version")

    File.open("output.txt", "w") do |file|
      # redirect stdout to the file
      $stdout.reopen(file)
      pid = spawn bin"conduit", "run", "--api.enabled", "true",
                                 "--api.grpc.address", ":0",
                                 "--api.http.address", ":0"
      sleep(5)
      # Kill process
      Process.kill("SIGKILL", pid)
    end
    assert_match "grpc API started", (testpath"output.txt").read
    assert_match "http API started", (testpath"output.txt").read
  end
end