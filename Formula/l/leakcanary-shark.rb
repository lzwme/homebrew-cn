class LeakcanaryShark < Formula
  desc "CLI Java memory leak explorer for LeakCanary"
  homepage "https:square.github.ioleakcanaryshark"
  url "https:github.comsquareleakcanaryreleasesdownloadv2.13shark-cli-2.13.zip"
  sha256 "cf84c1e23b3d29dbd28bd02cc448db57be93993db78d09c6573a8cd38259dea6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f48beb3d4abe9da3afa616317bd45574ff7f6712ff145a1e77140ac728ac70d0"
  end

  depends_on "openjdk"

  resource "sample_hprof" do
    url "https:github.comsquareleakcanaryrawv2.6shark-androidsrctestresourcesleak_asynctask_m.hprof"
    sha256 "7575158108b701e0f7233bc208decc243e173c75357bf0be9231a1dcb5b212ab"
  end

  def install
    # Remove Windows scripts
    rm_f Dir["bin*.bat"]

    libexec.install Dir["*"]
    (bin"shark-cli").write_env_script libexec"binshark-cli", Language::Java.overridable_java_home_env
  end

  test do
    resource("sample_hprof").stage do
      assert_match "1 APPLICATION LEAKS",
                   shell_output("#{bin}shark-cli --hprof .leak_asynctask_m.hprof analyze").strip
    end
  end
end