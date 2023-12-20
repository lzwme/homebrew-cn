class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https:github.comnginx-proxydocker-gen"
  url "https:github.comnginx-proxydocker-genarchiverefstags0.11.0.tar.gz"
  sha256 "15029c70d6b062440f37a04be6b978892b6397ce2cf8dbcdd95d3ffe64fef2ed"
  license "MIT"
  head "https:github.comnginx-proxydocker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "575808c11f52525f9cd04b89fd4b35274781656d6f861c5121302a90a0a02f9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7efd90ebe61ff116f2f5efc8831d848c97d4d16688f3aa7de55d9df31081b8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43c9de4e324e04ebbcf370a8ca4d5b9ab835b8d86cdbe098fb2b9d0be59b215a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8183584a36b18bc74a0fc4c4ef14a04fb83d133be935300e9878661f0e763163"
    sha256 cellar: :any_skip_relocation, ventura:        "86481f4329777680c1621d05bf32b74d09a43938a0368f3597638b119e5f7756"
    sha256 cellar: :any_skip_relocation, monterey:       "3d9c71a63660c103b1408a32386f1287b2f97f5be507aa86422f5be052915601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cff4546fabf5ff17648dc9c08eefdbc71ba28b64a39a3b3be084acbfcdd7524"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmddocker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}docker-gen --version")
  end
end