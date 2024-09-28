class Ringojs < Formula
  desc "CommonJS-based JavaScript runtime"
  homepage "https:ringojs.org"
  url "https:github.comringoringojsreleasesdownloadv4.0.0ringojs-4.0.0.tar.gz"
  sha256 "9aea219fc6b4929a7949a34521cb96207073d29aa88f89f9a8833e31e84b14d5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b257e897b4c3c6a0eda925822044fea179a8668bc9fb9ef0d73b65787c03204"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b257e897b4c3c6a0eda925822044fea179a8668bc9fb9ef0d73b65787c03204"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b257e897b4c3c6a0eda925822044fea179a8668bc9fb9ef0d73b65787c03204"
    sha256 cellar: :any_skip_relocation, sonoma:        "94a3251d5edc63236b82b66b85c8fb99e86af58409fbbde8e87da8e52d329b5c"
    sha256 cellar: :any_skip_relocation, ventura:       "94a3251d5edc63236b82b66b85c8fb99e86af58409fbbde8e87da8e52d329b5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b257e897b4c3c6a0eda925822044fea179a8668bc9fb9ef0d73b65787c03204"
  end

  depends_on "openjdk@17"

  def install
    rm Dir["bin*.cmd"]
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}bin*"]
    env = { RINGO_HOME: libexec }
    env.merge! Language::Java.overridable_java_home_env("17")
    bin.env_script_all_files libexec"bin", env
  end

  test do
    (testpath"test.js").write <<~EOS
      var x = 40 + 2;
      console.assert(x === 42);
    EOS
    system bin"ringo", "test.js"
  end
end