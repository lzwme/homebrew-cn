class Protolint < Formula
  desc "Pluggable linter and fixer to enforce Protocol Buffer style and conventions"
  homepage "https:github.comyoheimutaprotolint"
  url "https:github.comyoheimutaprotolintarchiverefstagsv0.50.4.tar.gz"
  sha256 "0ace13c72d9dd91df718f4453ff09406e6234748d6138a39327738af1c17235a"
  license "MIT"
  head "https:github.comyoheimutaprotolint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7309a9df2bd5408a5ed770cde46295c8eacc840eafc705e7198824bd40fb5f0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6950505cbdf8701e2708351888b8b68b3fce9b95107169d5870f9be1be83b647"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abdf724d6d9b8c895abde509a7b54f6b1fd5f0d0729214b5ef29e549aeaf5d16"
    sha256 cellar: :any_skip_relocation, sonoma:         "e091096198357d6d663a6c1bfcb01959923bb1457be694dca570bd96a8b2b80f"
    sha256 cellar: :any_skip_relocation, ventura:        "9045a11232232c4855d2adc96723d84028d8a78596499f3c0119902cd88dd714"
    sha256 cellar: :any_skip_relocation, monterey:       "5ca87db6bac8654db3eb42491e60d13b8d5c5922159d9a3b612cb09d044fe627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "216a04b84c7fa522e655e7237296324322da7069e8619cfa051d2758700ad3bb"
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