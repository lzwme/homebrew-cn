class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https:github.comcloudwegothriftgo"
  url "https:github.comcloudwegothriftgoarchiverefstagsv0.3.14.tar.gz"
  sha256 "676b84253709a2c51e690f8ac9dcfb90bffb1fc8f5a34763d1c8f5212018a225"
  license "Apache-2.0"
  head "https:github.comcloudwegothriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d0870ffae220b1c05c24aa78b06615d41e262b5ca088e42fb87242dbf27c1e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4093112295ad151b8cdd77d05046c71d7f92a101918baade67aebe60034517d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c903e2daca0cd3e0b074c64fc4061c77511dd12825daaf881f6d1d901e912f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "be003a84ee7fcc933cc221b0f0f2ae2becb9c5d47cacfc30c04be3c8e466d3b5"
    sha256 cellar: :any_skip_relocation, ventura:        "9ef708650fccfd92a975985e609e56e31a58cede2c8171c0175ea1cf212366ce"
    sha256 cellar: :any_skip_relocation, monterey:       "d17cb72e031a12c953955a2f1cbd2d0e17543e96ea6154eb35a00ccc68cb64ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cf4966e945e270946b8de3987661a8b2b875c6eb6508e5a4138100dd9ce1305"
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