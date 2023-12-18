class LeakcanaryShark < Formula
  desc "CLI Java memory leak explorer for LeakCanary"
  homepage "https:square.github.ioleakcanaryshark"
  url "https:github.comsquareleakcanaryreleasesdownloadv2.12shark-cli-2.12.zip"
  sha256 "2a9f176ab0e02834f46f0415f2e9626865e0ea0498398ae943075a7875f26bf6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dc617c59a6f33a75c07a14dc7e723847d5c8b82bc8391336e33243dfd2abd499"
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