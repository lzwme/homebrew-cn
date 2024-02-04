class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https:github.comBishopFoxcloudfox"
  url "https:github.comBishopFoxcloudfoxarchiverefstagsv1.13.2.tar.gz"
  sha256 "fe9c2373ba5b222d4bb681c322c670a825ca92576991891ea45498307878cf85"
  license "MIT"
  head "https:github.comBishopFoxcloudfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f962a9aa04d825b392dfd96b019f8f706288de59fe9b4e7bb1b294a28844ae0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa640eb94f5d9a516ba13c3d217c8e5474876a2c605a787ba046875f1ebba88f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9456c56889654b4472b053e7e772647418766e2aff78c869f4509284312a488a"
    sha256 cellar: :any_skip_relocation, sonoma:         "430ca9ec489f6b6a48bf97f22b9bf8f7f5b37baa27b2b497a64176c4f39d65d3"
    sha256 cellar: :any_skip_relocation, ventura:        "66fee72a39cb1153fcafdc85922fa1dd1f315a40e8c48b41fb0ff8c0fa76df67"
    sha256 cellar: :any_skip_relocation, monterey:       "5c98a7b6a8b216bac07d47d233d014345f695ed7e5d525117521db9407ec3b64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "316a986cb87a6e52e840c5e20a93d947535bec622ce7675e334ce431de94c6aa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin"cloudfox", "completion")
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}cloudfox --version")
  end
end