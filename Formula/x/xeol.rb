class Xeol < Formula
  desc "Xcanner for end-of-life software in container images, filesystems, and SBOMs"
  homepage "https:github.comxeol-ioxeol"
  url "https:github.comxeol-ioxeolarchiverefstagsv0.9.11.tar.gz"
  sha256 "db4bdfdc10edda477372e854569b5f6537567e034a26ffee028a54c9a6fbe3c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73af8e8679b25aaac4c8a51a7848bb9dcf4abd4ed0defda97fe6830439feced7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bc033db03f0c2fd19743a938e18df60880492e11b04d2e097469609e4396ef2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6359f9e7f775b91a8c8460c9e8f9982f2a67701da38f8daeee98a316e578cb0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c8b421c9a3c9668323962ac41e0563291a141a6b9be9aa7ea796714741a890b"
    sha256 cellar: :any_skip_relocation, ventura:        "96d07bb456b54824256c2aa9789f541b9d7ca492a67f6623d200b6e034679be9"
    sha256 cellar: :any_skip_relocation, monterey:       "f7228c4bbe81bedd71339e750edb43eddd4547cfe8738de1d22ace969eaa33da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d87ecd1fc4f4ae6fd27e9316bb5b70d64094760d6d17483cfbe1b350735737a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
      -X main.gitDescription=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdxeol"

    generate_completions_from_executable(bin"xeol", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}xeol version")

    output = shell_output("#{bin}xeol alpine:latest")
    assert_match "no EOL software has been found", output
  end
end