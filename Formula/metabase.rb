class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.46.3/metabase.jar"
  sha256 "5988d34062484b664e89ba152d8949498b3d8d9a3c51f40ce2ac7938058cd164"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab2b5c5539d9ea572bb22e4bd27edcfd09c597b6cf1890522e734d6c14fb2d91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab2b5c5539d9ea572bb22e4bd27edcfd09c597b6cf1890522e734d6c14fb2d91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab2b5c5539d9ea572bb22e4bd27edcfd09c597b6cf1890522e734d6c14fb2d91"
    sha256 cellar: :any_skip_relocation, ventura:        "ab2b5c5539d9ea572bb22e4bd27edcfd09c597b6cf1890522e734d6c14fb2d91"
    sha256 cellar: :any_skip_relocation, monterey:       "ab2b5c5539d9ea572bb22e4bd27edcfd09c597b6cf1890522e734d6c14fb2d91"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab2b5c5539d9ea572bb22e4bd27edcfd09c597b6cf1890522e734d6c14fb2d91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38fa3cbf1888d1f3c506b60d1a7749b443eb396465ad12935961479741ecbf5b"
  end

  head do
    url "https://github.com/metabase/metabase.git", branch: "master"

    depends_on "leiningen" => :build
    depends_on "node" => :build
    depends_on "yarn" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "./bin/build"
      libexec.install "target/uberjar/metabase.jar"
    else
      libexec.install "metabase.jar"
    end

    bin.write_jar_script libexec/"metabase.jar", "metabase"
  end

  service do
    run opt_bin/"metabase"
    keep_alive true
    require_root true
    working_dir var/"metabase"
    log_path var/"metabase/server.log"
    error_log_path "/dev/null"
  end

  test do
    system bin/"metabase", "migrate", "up"
  end
end