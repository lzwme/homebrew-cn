class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.16.3",
      revision: "b98b303afd6762c3dd64a8af597131e8948bcd69"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20516a043a05c4c37de4c757dbe629407e09159e65b7660a35977f20118ff491"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "260902640dc415ae5a658760559b42c87e9d57d855ed1f56c53fe42079b953c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc582445db9e32a549f13843d5dcb6148664546756665e6d72707abb153128a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8717ea4c23f61e2010ef5304f1fd1ec440e28e9af805f11eead8992eb65e7cbf"
    sha256 cellar: :any_skip_relocation, ventura:       "4fed6f367a75a2cb311000b0e48dfe847f4c8a777be73b3dbd3f51eb4979a2b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fa66f36e52ed4661fadfc73c10de49bca815c8daed25a4c24a10a6457c4cce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f99a3fccd23e020973f29d4beca804417b76e15b5ba5a248bb7cd12fe6c3857d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end