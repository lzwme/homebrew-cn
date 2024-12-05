class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https:weaviate.iodevelopersweaviate"
  url "https:github.comweaviateweaviatearchiverefstagsv1.27.6.tar.gz"
  sha256 "d8cad0339ccfd081be6afe1afd879f64bba224ed7ecbdb8b974853b536584330"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f3aa7911bd88edcb976948cd458ace1fe9804832ab6ca54710919d0137449bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f3aa7911bd88edcb976948cd458ace1fe9804832ab6ca54710919d0137449bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f3aa7911bd88edcb976948cd458ace1fe9804832ab6ca54710919d0137449bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b214070b4893a6df4e110c92b7b95ca1e889838ef50f6c544c1898f4b5c770c"
    sha256 cellar: :any_skip_relocation, ventura:       "8b214070b4893a6df4e110c92b7b95ca1e889838ef50f6c544c1898f4b5c770c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "020726bf37280847fd20f7ee47446d07f2db371b9168a59cd675f08036fa24ae"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comweaviateweaviateusecasesbuild.Version=#{version}
      -X github.comweaviateweaviateusecasesbuild.BuildUser=#{tap.user}
      -X github.comweaviateweaviateusecasesbuild.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdweaviate-server"
  end

  test do
    port = free_port
    pid = spawn bin"weaviate", "--host", "0.0.0.0", "--port", port.to_s, "--scheme", "http"
    sleep 10
    assert_match version.to_s, shell_output("curl localhost:#{port}v1meta")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end