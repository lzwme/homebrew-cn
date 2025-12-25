class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://ghfast.top/https://github.com/sunny0826/kubecm/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "5ac6928cf87092a9ef6c5b620065b4da0fe981c716566e0aaa9959f007294362"
  license "Apache-2.0"
  head "https://github.com/sunny0826/kubecm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6445d2e011f6faecf4e72d5ddf2fe0d995c67589ecb9c01aa3fa26badf5a369"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6445d2e011f6faecf4e72d5ddf2fe0d995c67589ecb9c01aa3fa26badf5a369"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6445d2e011f6faecf4e72d5ddf2fe0d995c67589ecb9c01aa3fa26badf5a369"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0dcd292a68b2e202be690ba95de57a2d5ccbb2cefff048d2084e2f523873590"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09580199b744d164a8992984f270b007711354d3daedc68f2378ed20ae9ed194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b56304fc2d7c89816c020b98934f5d5c2005459248b1def5bb6f0dc58f2e86a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end