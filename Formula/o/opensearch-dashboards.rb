class OpensearchDashboards < Formula
  desc "Open source visualization dashboards for OpenSearch"
  homepage "https:opensearch.orgdocsdashboardsindex"
  url "https:github.comopensearch-projectOpenSearch-Dashboards.git",
      tag:      "2.18.0",
      revision: "543420113443b184e313e489215a88090d60e2b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43d27f18dc92a6ffdb28fe4f0c61c3a36e28c75e9f4c8a366cfad62a506df579"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43d27f18dc92a6ffdb28fe4f0c61c3a36e28c75e9f4c8a366cfad62a506df579"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10fe2750d077f7e428b9e916341658cd49184119ef4fe700f45db3157874772c"
    sha256 cellar: :any_skip_relocation, sonoma:        "27f3459d79e517a890962e0600070cd11fe04f7a529a978a69acc3526bb20837"
    sha256 cellar: :any_skip_relocation, ventura:       "b989d7b832a389f95ec044c849136d4051dfdc78875cad0298793520aa73a50b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc5d44cfc210ebfeb7777d65981f5c008729bb0d81fde58c83240f9fde62c892"
  end

  # Match deprecation date of `node@18`.
  # disable! date: "2025-04-30", because: "uses deprecated `node@18`"
  deprecate! date: "2024-10-29", because: "uses deprecated `node@18`"

  depends_on "yarn" => :build
  depends_on "opensearch" => :test
  depends_on "node@18"

  # - Do not download node and discard all actions related to this node
  patch :DATA

  def install
    system "yarn", "osd", "bootstrap"
    system "node", "scriptsbuild", "--release", "--skip-os-packages", "--skip-archives", "--skip-node-download"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    cd "buildopensearch-dashboards-#{version}-#{os}-#{arch}" do
      inreplace "binuse_node",
                NODE=".+",
                "NODE=\"#{Formula["node@18"].opt_bin"node"}\""

      inreplace "configopensearch_dashboards.yml",
                #\s*pid\.file: .+$,
                "pid.file: #{var}runopensearchDashboards.pid"

      (etc"opensearch-dashboards").install Dir["config*"]
      rm_r(Dir["{config,data,plugins}"])

      prefix.install Dir["*"]
    end
  end

  def post_install
    (var"logopensearch-dashboards").mkpath

    (var"libopensearch-dashboards").mkpath
    ln_s var"libopensearch-dashboards", prefix"data" unless (prefix"data").exist?

    (var"opensearch-dashboardsplugins").mkpath
    ln_s var"opensearch-dashboardsplugins", prefix"plugins" unless (prefix"plugins").exist?

    ln_s etc"opensearch-dashboards", prefix"config" unless (prefix"config").exist?
  end

  def caveats
    <<~EOS
      Data:    #{var}libopensearch-dashboards
      Logs:    #{var}logopensearch-dashboardsopensearch-dashboards.log
      Plugins: #{var}opensearch-dashboardsplugins
      Config:  #{etc}opensearch-dashboards
    EOS
  end

  service do
    run opt_bin"opensearch-dashboards"
    log_path var"logopensearch-dashboards.log"
    error_log_path var"logopensearch-dashboards.log"
  end

  test do
    ENV["BABEL_CACHE_PATH"] = testpath".babelcache.json"

    os_port = free_port
    (testpath"data").mkdir
    (testpath"logs").mkdir
    fork do
      exec Formula["opensearch"].bin"opensearch", "-Ehttp.port=#{os_port}",
                                                   "-Epath.data=#{testpath}data",
                                                   "-Epath.logs=#{testpath}logs"
    end

    (testpath"config.yml").write <<~YAML
      server.host: "127.0.0.1"
      path.data: #{testpath}data
      opensearch.hosts: ["http:127.0.0.1:#{os_port}"]
    YAML

    osd_port = free_port
    fork { exec bin"opensearch-dashboards", "-p", osd_port.to_s, "-c", testpath"config.yml" }

    output = nil

    max_attempts = 100
    attempt = 0

    loop do
      attempt += 1
      break if attempt > max_attempts

      sleep 3

      output = Utils.popen_read("curl", "--location", "--silent", "127.0.0.1:#{osd_port}")
      break if output.present? && output != "OpenSearch Dashboards server is not ready yet"
    end

    assert_includes output, "<title>OpenSearch Dashboards<title>"
  end
end

__END__
diff --git asrcdevbuildbuild_distributables.ts bsrcdevbuildbuild_distributables.ts
index d764c5df28..e37b71e04a 100644
--- asrcdevbuildbuild_distributables.ts
+++ bsrcdevbuildbuild_distributables.ts
@@ -63,8 +63,6 @@ export async function buildDistributables(log: ToolingLog, options: BuildOptions
    *
   await run(Tasks.VerifyEnv);
   await run(Tasks.Clean);
-  await run(options.downloadFreshNode ? Tasks.DownloadNodeBuilds : Tasks.VerifyExistingNodeBuilds);
-  await run(Tasks.ExtractNodeBuilds);

   **
    * run platform-generic build tasks
diff --git asrcdevbuildtaskscreate_archives_sources_task.ts bsrcdevbuildtaskscreate_archives_sources_task.ts
index 5ba01ad129..b4ecbb0d3d 100644
--- asrcdevbuildtaskscreate_archives_sources_task.ts
+++ bsrcdevbuildtaskscreate_archives_sources_task.ts
@@ -41,38 +41,6 @@ export const CreateArchivesSources: Task = {
           source: build.resolvePath(),
           destination: build.resolvePathForPlatform(platform),
         });
-
-        log.debug(
-          'Generic build source copied into',
-          platform.getNodeArch(),
-          'specific build directory'
-        );
-
-         copy node.js install
-        await scanCopy({
-          source: (await getNodeDownloadInfo(config, platform)).extractDir,
-          destination: build.resolvePathForPlatform(platform, 'node'),
-        });
-
-         ToDo [NODE14]: Remove this Node.js 14 fallback download
-         Copy the Node.js 14 binaries into nodefallback to be used by `use_node`
-        if (platform.getBuildName() === 'darwin-arm64') {
-          log.warning(`There are no fallback Node.js versions released for darwin-arm64.`);
-        } else {
-          await scanCopy({
-            source: (
-              await getNodeVersionDownloadInfo(
-                NODE14_FALLBACK_VERSION,
-                platform.getNodeArch(),
-                platform.isWindows(),
-                config.resolveFromRepo()
-              )
-            ).extractDir,
-            destination: build.resolvePathForPlatform(platform, 'node', 'fallback'),
-          });
-        }
-
-        log.debug('Node.js copied into', platform.getNodeArch(), 'specific build directory');
       })
     );
   },
diff --git asrcdevnoticegenerate_build_notice_text.js bsrcdevnoticegenerate_build_notice_text.js
index b32e200915..2aab53f3ea 100644
--- asrcdevnoticegenerate_build_notice_text.js
+++ bsrcdevnoticegenerate_build_notice_text.js
@@ -48,7 +48,7 @@ export async function generateBuildNoticeText(options = {}) {

   const packageNotices = await Promise.all(packages.map(generatePackageNoticeText));

-  return [noticeFromSource, ...packageNotices, generateNodeNoticeText(nodeDir, nodeVersion)].join(
+  return [noticeFromSource, ...packageNotices, ''].join(
     '\n---\n'
   );
 }