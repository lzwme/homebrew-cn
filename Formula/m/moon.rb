class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.27.8.tar.gz"
  sha256 "62940764bdaa382b7f741c98c5e0159e78103b0fac579455293f589b91161749"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "502abc7bdc41a95b99a470df2c142c23a205b20a86d08a75b13c077fc5537fe5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f19f8fa296d36e503f58f109e61ac27026f568d99321ea224a83579ba1d343b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bccdfa296d35e75043235c3f6f2b02e5ac9f352d8841b0e6fb9855dfd70628a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "7681d37dd6393b7a238e92eaac8e71a06390f17f1953ae57c83eb3920782e115"
    sha256 cellar: :any_skip_relocation, ventura:        "7e70dc2aef5a255bee37424a095088174057998b888e6df6fd916f50a5a5de9d"
    sha256 cellar: :any_skip_relocation, monterey:       "aa1228b7552ed7f4d669def70a768ef87926c546016dcb094282006fe3cb27c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd403c477f1c24c1f45d68ad30eca4f7a44dc0291c3e013788b53a1325055fba"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")
    generate_completions_from_executable(bin"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec"bin").install f
      (binbasename).write_env_script libexec"bin"basename, MOON_INSTALL_DIR: opt_prefix"bin"
    end
  end

  test do
    system bin"moon", "init", "--minimal", "--yes"
    assert_predicate testpath".moon""workspace.yml", :exist?
  end
end