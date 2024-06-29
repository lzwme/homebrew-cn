class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https:github.comyoheimutaprotolint"
  url "https:github.comyoheimutaprotolintarchiverefstagsv0.50.2.tar.gz"
  sha256 "8314e7d295ff2f9f0e537d932c0036fb5e3352f14e09fa9c54dea52eded3fd7d"
  license "MIT"
  head "https:github.comyoheimutaprotolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1fe1abe977fd81c14b6ad82f3e284300137b085b6f8b828778b7493bd91f3cf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b9f3475e08b3d0c3d972a6eeb8fd310ddab01e136bfabdcf363a4a6e311a863"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c2d70cf606f98846a1998930b43d5c963bdcad1b1b3e630b890689189b76be1"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a489c0ee2571fce85a431a96ef51b80b9e3279b9fe13df655a01e976bc662f3"
    sha256 cellar: :any_skip_relocation, ventura:        "97e744d6a3216889e4b2dd7ab265ee26209c823af28fd6a9f61c6268e87e8981"
    sha256 cellar: :any_skip_relocation, monterey:       "a5342bf9487852e0c9ce26924f17e8587d224cc0448b579f5128360f286e00ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0869b80ddafe604f867cdc22b6a825beeb4953828be500d27eeea15b25fbc526"
  end

  depends_on "go" => :build

  def install
    protolint_ldflags = %W[
      -s -w
      -X github.comyoheimutaprotolintinternalcmd.version=#{version}
      -X github.comyoheimutaprotolintinternalcmd.revision=#{tap.user}
    ]
    protocgenprotolint_ldflags = %W[
      -s -w
      -X github.comyoheimutaprotolintinternalcmdprotocgenprotolint.version=#{version}
      -X github.comyoheimutaprotolintinternalcmdprotocgenprotolint.revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: protolint_ldflags), ".cmdprotolint"
    system "go", "build",
      *std_go_args(ldflags: protocgenprotolint_ldflags, output: bin"protoc-gen-protolint"),
      ".cmdprotoc-gen-protolint"

    pkgshare.install Dir["_exampleproto*.proto"]
  end

  test do
    cp_r Dir[pkgshare"*.proto"], testpath

    output = "[invalidFileName.proto:1:1] File name \"invalidFileName.proto\" " \
             "should be lower_snake_case.proto like \"invalid_file_name.proto\"."
    assert_equal output,
      shell_output("#{bin}protolint lint #{testpath}invalidFileName.proto 2>&1", 1).chomp

    output = "Quoted string should be \"other.proto\" but was 'other.proto'."
    assert_match output, shell_output("#{bin}protolint lint #{testpath}simple.proto 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}protolint version")
    assert_match version.to_s, shell_output("#{bin}protoc-gen-protolint version")
  end
end