class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https:docs.ignite.com"
  url "https:github.comignitecliarchiverefstagsv28.8.1.tar.gz"
  sha256 "3cc70f2c812287bb77303a95ac3b718381ab380aca37591fecfc8e7bae29008d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a52eadf8ab10ab42b9f6ce8cae82b7be0685711f281c2daffae0961ada414374"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c1aa00fe6409a01f787a04589b077b54af3d8468c09de0f5b2e1baa4d969f7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9678eb6685031d7305e117634a50f1d45d91fd8893d9c1ec0b8e97e51a6dd590"
    sha256 cellar: :any_skip_relocation, sonoma:        "76fe934190cf56305f3b2b226f70c7a88cab800e7997279e0d84a999b3b76a38"
    sha256 cellar: :any_skip_relocation, ventura:       "08678ee6c1c2ccef428f47490eab915d6b632bf7c4ee32dbb59e3caf60239679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a4b0c7bb93ba536ac79515a709c4dd1d2d938b9fd3fe67f78c27450077ceebc"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin"ignite"), ".ignitecmdignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin"ignite", "s", "chain", "mars"
    sleep 2
    assert_path_exists testpath"marsgo.mod"
  end
end