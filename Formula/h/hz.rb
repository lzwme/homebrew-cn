class Hz < Formula
  desc "Golang HTTP framework for microservices"
  homepage "https:github.comcloudwegohertz"
  url "https:github.comcloudwegohertzarchiverefstagscmdhzv0.9.7.tar.gz"
  sha256 "c2d894db10414648cd4d131ca1405cb1fde0dcdd3287fbd4c4623c9916ae6717"
  license "Apache-2.0"
  head "https:github.comcloudwegohertz.git", branch: "develop"

  livecheck do
    url :stable
    regex(%r{^cmdhzv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ce4bbaf5113e48f449db2b510cd18797b23c40035d488bc1fc8a364a16d9a6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ce4bbaf5113e48f449db2b510cd18797b23c40035d488bc1fc8a364a16d9a6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ce4bbaf5113e48f449db2b510cd18797b23c40035d488bc1fc8a364a16d9a6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "464319954276a791ad9366da2feb521563721204dc1ffe4c18e733b4a6acd4c0"
    sha256 cellar: :any_skip_relocation, ventura:       "464319954276a791ad9366da2feb521563721204dc1ffe4c18e733b4a6acd4c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9906a09535199349b1e5bae6c8b5ffd62b9f2a74437480d4783e705d4cc161a6"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmdhz" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
    bin.install_symlink bin"hz" => "thrift-gen-hertz"
    bin.install_symlink bin"hz" => "protoc-gen-hertz"
  end

  test do
    ENV["GOPATH"] = testpath

    output = shell_output("#{bin}hz --version 2>&1")
    assert_match "hz version v#{version}", output

    system bin"hz", "new", "--mod=test"
    assert_path_exists testpath"main.go"
    refute_predicate (testpath"main.go").size, :zero?
  end
end