class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https:lune-org.github.iodocs"
  url "https:github.comlune-orglunearchiverefstagsv0.9.1.tar.gz"
  sha256 "70e093ca0d15f392ad9e72ba0d73b453a6d97fc999ec1f851bad03c24043b807"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9fb6b09e9422e5df2a591f678bee23104066b852a36b6b89428ec9042096e53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfe3aeac4473372e6f0614cc2940ddae07085aa81a45eb1e28acdcb3f9045025"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f04c9661defc5a27a65ba4ae7df47f68a9057bbcfb747d7826fc3b355291a4dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3533b977018227a191ec80247188faa6f0dae781353246ec74a12d89f6eb8ef"
    sha256 cellar: :any_skip_relocation, ventura:       "249f622b60de1a42240069569b5074902e3637b66cfe55b6f5365c1bcbeec1da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b616fc2c6e280c036509ef3d4bc0ce0628752e11d9cc5d04043e2e06bc6d43dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e150bb4afceee274b9acc560227bc39acd8aae0eb8bfdeadbabee4d0e05d28ad"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args(path: "crateslune")
  end

  test do
    (testpath"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}lune run test.lua").chomp
  end
end