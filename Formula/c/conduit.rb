class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https:conduit.io"
  url "https:github.comConduitIOconduitarchiverefstagsv0.9.1.tar.gz"
  sha256 "48c05a3d59e274370005476e5205ec416f283ae8728b2ca28c3cdd49f4e0df34"
  license "Apache-2.0"
  head "https:github.comConduitIOconduit.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c7ecf3d96ef50d37a291a508f693ca5fa8c6cb82013079cc854cdbf69343936"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abf7164acc4759d0a87696aaccf4a2aa43730a03552e9ef1e19f57da06196cd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a9208d2bfa759257eaf791bf0bec07a1c7b107c1b61a3117084741375dd3786"
    sha256 cellar: :any_skip_relocation, sonoma:         "0558ec5f40dff2fc8aef1f5bff93789feefa748ea7af95c9cb114884577a522e"
    sha256 cellar: :any_skip_relocation, ventura:        "8c3662d514240acd7ce8af1e574c9b4b50b57f65f24c3b2769b3ef837a925f70"
    sha256 cellar: :any_skip_relocation, monterey:       "f58f6b460e6661bd853bddab786cf3eed20e1184ebc31ffa3e97118e3cc57a0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24f7cb53e3165446b2f9bf2b27d4c0ba52faedc59e71ea8b946d80328c95aeee"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "conduit"
  end

  test do
    # Assert conduit version
    assert_match(version.to_s, shell_output("#{bin}conduit -version"))

    File.open("output.txt", "w") do |file|
      # redirect stdout to the file
      $stdout.reopen(file)
      pid = fork do
        # Run conduit with random free ports for gRPC and HTTP servers
        exec bin"conduit", "--grpc.address", ":0",
                            "--http.address", ":0"
      end
      sleep(5)
      # Kill process
      Process.kill("SIGKILL", pid)
    end
    assert_match "grpc server started", (testpath"output.txt").read
    assert_match "http server started", (testpath"output.txt").read
  end
end