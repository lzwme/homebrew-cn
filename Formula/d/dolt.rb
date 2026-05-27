class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "f93f8e6536344a01f15c0037ab9ce450638ce2ee0937bd933a241b6107b625a9"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d85a319ecded6617b630b3a4bf5649e1569e64ab27eddd89a30ac64982f67790"
    sha256 cellar: :any,                 arm64_sequoia: "9555237318b41a1d3760569c7a94229f345e49e26911ccaa2ab07ac6dd51fdce"
    sha256 cellar: :any,                 arm64_sonoma:  "d0be35e0088c2b6bb922cf9a8011f0cd23eab1f1ba482aa0fe63fb93ee0beb55"
    sha256 cellar: :any,                 sonoma:        "14c71ccb65759c417e09a828cd5cc962c5e2b950f563fca780d4d81f61905c79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cc787c9b165736beb1855cc3a35ebcbbbb273c62870f2d54468be598ab7f7dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b079e9cfff015e3218064d55324c7f937240df6188f163de1edd79a81d44a594"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
    (var/"dolt").mkpath
    (etc/"dolt").mkpath
    touch etc/"dolt/config.yaml"
  end

  service do
    run [opt_bin/"dolt", "sql-server", "--config", etc/"dolt/config.yaml"]
    keep_alive true
    log_path var/"log/dolt.log"
    error_log_path var/"log/dolt.error.log"
    working_dir var/"dolt"
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end