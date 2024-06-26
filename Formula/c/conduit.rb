class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https:conduit.io"
  url "https:github.comConduitIOconduitarchiverefstagsv0.10.3.tar.gz"
  sha256 "34fea807f78c49603a0fe67107621b3df9bd4ee75ef1a0a1ae531ef8256e9e33"
  license "Apache-2.0"
  head "https:github.comConduitIOconduit.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfcde85d1b05106f25ab19ab2306e353dd1217953b502ead27d1e152a0244dc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9be41f08c90984da9d2a3fef50196d76a4fc897da6c00b87f416bcd58a717cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63696fa74e5d490086be4687a8eb80c90d2c14e4caca5c441271e30daafbedc0"
    sha256 cellar: :any_skip_relocation, sonoma:         "d869130285a55987ebcfc90d16a13484275d4530aec9f63b06b702d70608512c"
    sha256 cellar: :any_skip_relocation, ventura:        "5029eaf45bd62f4d33a77a5a939995bc73da1759363413d2fa71ee351f98bcde"
    sha256 cellar: :any_skip_relocation, monterey:       "ae62e2ad2673739e9d525385377d60434cbcd41b149a6feeb8d2a52c61d8ed3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0be92a2554338aa340a3e1b6c7633b96335766d17890a5d21543cee3741ac3aa"
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