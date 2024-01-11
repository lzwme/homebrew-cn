class Thriftgo < Formula
  desc "Implementation of thrift compiler in go language with plugin mechanism"
  homepage "https:github.comcloudwegothriftgo"
  url "https:github.comcloudwegothriftgoarchiverefstagsv0.3.5.tar.gz"
  sha256 "8258651df3bf3b64f0616737da50dc543ce0bb69ca9acf532137b89bc96073f2"
  license "Apache-2.0"
  head "https:github.comcloudwegothriftgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c4f2605da23404d9f3fdaa095b7ebb927d200abb1672f5e0a1c09bfb76dc096"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd7808624e7df3d1d0f5b180a914e251a5d5c914003e6219bcd92ea55e35f380"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44693ac1176c947bc262f2a32a39571934695204be3df174b8b8cc106bf5bfa6"
    sha256 cellar: :any_skip_relocation, sonoma:         "edb2dc8069ccdf38aacc8038c1625751ad84ac97432d1fd69da64c60a9924e3a"
    sha256 cellar: :any_skip_relocation, ventura:        "b99ae690d71b3b6dd327261d81a4ce6195fb8e22d3ca7a5f2e05cd03cb24660a"
    sha256 cellar: :any_skip_relocation, monterey:       "6a9815c4afef3d56604f24d50e27c129b5156ddd23b8bc81cd01072ddc7e16d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3400bb8601932df9c9bfa85aa66ffe3fef113e31210a13c25e7d8167cb48e2b"
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