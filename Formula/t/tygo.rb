class Tygo < Formula
  desc "Generate Typescript types from Golang source code"
  homepage "https://github.com/gzuidhof/tygo"
  url "https://github.com/gzuidhof/tygo.git",
      tag:      "v0.2.7",
      revision: "6cb2668c1edb239b4a1819dc07e9c1d79574982f"
  license "MIT"
  head "https://github.com/gzuidhof/tygo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06840c78c9543754f717fa1a31b903ca272413ca6aad5b50627b8c28cf94fcbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "337e88a1d23b9bc8247f7a571130e7863522ea0dcf5a1166c39e9229189ffa0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6149ca68dc4c013c2dd6cdb0e624c0f77aef8366dafa55a6e076926811093c92"
    sha256 cellar: :any_skip_relocation, ventura:        "6a102cd6741f65a9581443ef88fd1355529659d1438dc8aa174698f9017c4256"
    sha256 cellar: :any_skip_relocation, monterey:       "4d6d8aab5f87ddbff1ca65706ca868d776d46b5d982fcec75e67cd9da36db8c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0929a22e12b25b62ab6caff989c89ceeadc914fa3aa5be4af49b4e8825d2a865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "682dac5d06ba4e8feb56174b9089e6e8dd4b44fe1b8b88138c653f546843982e"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = %W[
      -s -w
      -X github.com/gzuidhof/tygo/cmd.version=#{version}
      -X github.com/gzuidhof/tygo/cmd.commit=#{Utils.git_head}
      -X github.com/gzuidhof/tygo/cmd.commitDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"tygo", "completion")
    pkgshare.install "examples"
  end

  test do
    (testpath/"tygo.yml").write <<~EOS
      packages:
        - path: "simple"
          type_mappings:
            time.Time: "string /* RFC3339 */"
            null.String: "null | string"
            null.Bool: "null | boolean"
            uuid.UUID: "string /* uuid */"
            uuid.NullUUID: "null | string /* uuid */"
    EOS

    system "go", "mod", "init", "simple"
    cp pkgshare/"examples/simple/simple.go", testpath
    system bin/"tygo", "--config", testpath/"tygo.yml", "generate"
    assert_match "source: simple.go", (testpath/"index.ts").read

    assert_match version.to_s, shell_output("#{bin}/tygo --version")
  end
end