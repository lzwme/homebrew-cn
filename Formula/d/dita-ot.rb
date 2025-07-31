class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://ghfast.top/https://github.com/dita-ot/dita-ot/releases/download/4.3.4/dita-ot-4.3.4.zip"
  sha256 "011c65bbe55b917f572e8d8e81a5518504cff0706b436f1c8a6565a1d2d98f08"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf827317098a83364824b48f4dabb3ffc9597da35fc2fdb75367f18be79be202"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf827317098a83364824b48f4dabb3ffc9597da35fc2fdb75367f18be79be202"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf827317098a83364824b48f4dabb3ffc9597da35fc2fdb75367f18be79be202"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a6675abd313544391cd5428cc250f817f815296f0a59ab1d0ae24211cfbd626"
    sha256 cellar: :any_skip_relocation, ventura:       "8a6675abd313544391cd5428cc250f817f815296f0a59ab1d0ae24211cfbd626"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d59169aa5d2685490469408bb0ea04e69103d141a61dbb84f34fe622c69f85b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d59169aa5d2685490469408bb0ea04e69103d141a61dbb84f34fe622c69f85b6"
  end

  depends_on "openjdk"

  def install
    rm(Dir["bin/*.bat", "config/env.bat", "startcmd.*"])
    libexec.install Dir["*"]
    (bin/"dita").write_env_script libexec/"bin/dita", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    system bin/"dita", "--input=#{libexec}/docsrc/site.ditamap",
           "--format=html5", "--output=#{testpath}/out"
    assert_path_exists testpath/"out/index.html"
  end
end