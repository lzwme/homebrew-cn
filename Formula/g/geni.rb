class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https:github.comemilprivergeni"
  url "https:github.comemilprivergeniarchiverefstagsv1.0.7.tar.gz"
  sha256 "59a6ebc1319d52c1f1e077f6fb8111e0bd94220b0996c8ab05dcaad325121601"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8f5f9b88ea85855e21e476f9d9da5e49825faa917a46f81d33518b3186370cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe9134487c7115fb6e5376270d1db3351ff2345dfb4daac64d58acdd7af6e0ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d031a493afc736a262f68e2caa84b2e21dff5e84cb4b9e5831b4d44a5ea9465a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0544c6909ac53b990856ef3ba72760efbd99f568f2eda3985a93de0c9fa7baa1"
    sha256 cellar: :any_skip_relocation, ventura:        "6c743709fe3c270e0d914a0e0af8e5916965f63dbf96d003e8293675edba2966"
    sha256 cellar: :any_skip_relocation, monterey:       "fc2981532db3a7a50b3dba20859aa4225792b6aa966d3f4da5a10036afcfef96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6cd174a3e1d54f600c372e81ce95f818e15627a2059dccb0ef0f6275b7ccab7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DATABASE_URL"] = "sqlite3:test.sqlite"
    system bin"geni", "create"
    assert_predicate testpath"test.sqlite", :exist?, "failed to create test.sqlite"
    assert_match version.to_s, shell_output("#{bin}geni --version")
  end
end