class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https:github.comcloudwegothriftgo"
  url "https:github.comcloudwegothriftgoarchiverefstagsv0.3.8.tar.gz"
  sha256 "a695bb80bb8aaf8ede43fa79a1e2b08ef7752af9f89066241cbe750a32c2175e"
  license "Apache-2.0"
  head "https:github.comcloudwegothriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a83aeac4ce3273fa83dbbd440def1c39a420d3ce8d9f8a3c4cfd9c318085446c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99579205ad7274d3f796027637dc599e35856c43fa0c895df9bb34c3e7247803"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "690b87de3318ee5b1e434846529672a9ad1dc930688fe9911c326af0aeb623dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "fade7f1d314c82530ba6a4a91803505857e2f90e8b50b529bee49c3170804db9"
    sha256 cellar: :any_skip_relocation, ventura:        "873d9562c34cc05c02f07cd6d7fd81854d214900198c6881ae3afa3e1da7090a"
    sha256 cellar: :any_skip_relocation, monterey:       "016c7423eb4b8187f0073673307647d3f8f81f430978aca223adca179be7578a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28d009cdcc5e1b8cf3b643441da444e0c2991232c1c7f16ba2f36fb7b6635fe8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}thriftgo --version 2>&1")
    assert_match "thriftgo #{version}", output

    thriftfile = testpath"test.thrift"
    thriftfile.write <<~EOS
      namespace go api
      struct Request {
              1: string message
      }
      struct Response {
              1: string message
      }
      service Hello {
          Response echo(1: Request req)
      }
    EOS
    system "#{bin}thriftgo", "-o=.", "-g=go", "test.thrift"
    assert_predicate testpath"api""test.go", :exist?
    refute_predicate (testpath"api""test.go").size, :zero?
  end
end