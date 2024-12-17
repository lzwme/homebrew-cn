class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https:github.comMacmodgodap"
  url "https:github.comMacmodgodaparchiverefstagsv2.10.2.tar.gz"
  sha256 "5d2a42e2830334fdf3f6dd00446bfb5ef6ec8b4ec9119ec963d985d78293ca9a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6f4e60fb238bf1f70c096fbfafa497d660d237aae5eae2b60b85fca0cfa6aef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6f4e60fb238bf1f70c096fbfafa497d660d237aae5eae2b60b85fca0cfa6aef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6f4e60fb238bf1f70c096fbfafa497d660d237aae5eae2b60b85fca0cfa6aef"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8a04193a906366d25caffe20175eb0b0d7349897705dbee07133f70859d7e4e"
    sha256 cellar: :any_skip_relocation, ventura:       "d8a04193a906366d25caffe20175eb0b0d7349897705dbee07133f70859d7e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fe1c2ede2bf558effed5b154f6187e57b5d50f7eba25563b999eb356cdad9af"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin"godap",  "completion")
  end

  test do
    output = shell_output("#{bin}godap -T 1 203.0.113.1 2>&1", 1)
    assert_match "LDAP Result Code 200 \"Network Error\": dial tcp 203.0.113.1:389: io timeout", output

    assert_match version.to_s, shell_output("#{bin}godap version")
  end
end